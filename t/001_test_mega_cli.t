#
#===============================================================================
#
#         FILE: 001_test_mega_cli.t
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 20.10.2018 20:47:03
#     REVISION: ---
#===============================================================================

use utf8;
use strict;
use warnings;
use lib 'lib';
use Mega::Cli;
use Data::Printer;

use Test::More 'no_plan';                      # last test to print


my $MEGA_LOGIN          = $ENV{MEGA_LOGIN};
my $MEGA_PASSWORD       = $ENV{MEGA_PASSWORD};

# Find mega in different path
my $mega = createMegaObj() or BAIL_OUT("Can't create Mega::Cli object");
isa_ok ($mega, 'Mega::Cli');

testCreateSeveralObject();

testMegaLogin();


sub testCreateSeveralObject {
    
    eval {
        my $mega = createMegaObj();
    };
    like ($@, qr/Can't lock port/, 'Test create several mega objects');
}


sub createMegaObj {
    my $mega; 
    my @paths = split(/:/, $ENV{PATH});
    for my $path (@paths) {
        eval {
            $mega = Mega::Cli->new(
                -path           => $path,
            );
        };
        if ($@) {
            if ($@ =~ /^Command:/) {
                print "Not found mega in path: $path\n";
            }
            else {
                die $@;
            }
        }
        else {
            print "Found mega in path: $path\n";
            last;
        }
    }
    
    return $mega;
}

sub testMegaLogin {
    SKIP: {
        skip "Not defined env: 'MEGA_LOGIN'" if not defined $MEGA_LOGIN;
        skip "Not defined env: 'MEGA_PASSWORD'" if not defined $MEGA_PASSWORD;
        my $login_res = $mega->login(
                        -login      => $MEGA_LOGIN,
                        -password   => $MEGA_PASSWORD,
                    );
        ok ($login_res, 'Login to mega');
        eval {
            $mega->login(
                            -login      => $MEGA_LOGIN,
                            -password   => '',
                        );
        };
        ok ($@, "Fail Login to mega: $@");
    };
}


