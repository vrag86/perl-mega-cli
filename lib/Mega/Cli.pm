#
#===============================================================================
#
#         FILE: Cli.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 20.10.2018 20:39:31
#     REVISION: ---
#===============================================================================
package Mega::Cli;

use utf8;
use strict;
use warnings;
use File::Spec;
use Lock::Socket;
use Carp qw/carp croak/;


my $MEGA_CMD = {
    'mega_login'    => 'mega-login',
    'mega_logout'   => 'mega-logout',

};

my $DEFAULT_PATH        = '/usr/bin';
my $DEFAULT_LOCK_PORT   = 40000;

sub new {
    my ($class, %opt) = @_;
    my $self = {};

    $self->{path}           = $opt{-path}           // $DEFAULT_PATH;
    $self->{lock_port}      = $opt{-lock_port}      // $DEFAULT_LOCK_PORT;

    $self->{lock} = Lock::Socket->new(port => $self->{lock_port});
    eval {
        $self->{lock}->lock;
    };
    if ($@) {
        croak "Can't lock port $self->{lock_port}";
    }

    # Check exists all ptrogramm
    for my $cmd (keys %$MEGA_CMD) {
        my $cmd_path = File::Spec->catfile($self->{path}, $MEGA_CMD->{$cmd});
        if (not -f $cmd_path) {
            croak "Command: $cmd not found: $cmd_path";
        }
    }

    bless $self, $class;
    return $self;
}


sub login {
    my ($self, %opt) = @_;
    $self->{login}          = $opt{-login}          // croak "You must specify '-login' param";
    $self->{password}       = $opt{-password}       // croak "You must specify '-password' param";

    $self->logout();

    my $cmd = File::Spec->catfile($self->{path}, $MEGA_CMD->{mega_login});
    my $login_res = `$cmd '$self->{login}' '$self->{password}'`;
    if ($login_res) {
        croak "Can't login to mega: $login_res";
    }

    return 1;
}

sub logout {
    my ($self) = @_;

    my $cmd = File::Spec->catfile($self->{path}, $MEGA_CMD->{mega_logout});
    `$cmd`;
    return 1;
}


sub DESTROY {
    my ($self) = @_;
    if ($self->{lock}) {
        $self->{lock}->unlock;
    }
}

1;
