use strict;
use warnings;
use utf8;

use DBIx::Sunny;
use Digest::SHA1 qw(sha1_hex);

sub dbh {
    my $self = shift;

    $self->{_dbh} //= do {
        my %db = (
            host     => $ENV{ISUBATA_DB_HOST}      || 'localhost',
            port     => $ENV{ISUBATA_DB_PORT}      || 3306,
            username => $ENV{ISUBATA_DB_USER}      || 'root',
            password => $ENV{ISUBATA_DB_PASSWORD},
        );
        DBIx::Sunny->connect(
            "dbi:mysql:dbname=isubata;host=$db{host};port=$db{port}", $db{username}, $db{password}, {
                Callbacks => {
                    connected => sub {
                        my $dbh = shift;
                        $dbh->do(q{SET SESSION sql_mode='TRADITIONAL,NO_AUTO_VALUE_ON_ZERO,ONLY_FULL_GROUP_BY'});
                        $dbh->do(q{SET NAMES utf8mb4});
                        return;
                    },
                },
            },
        );
    };
}

my $rows = dbh->select_all(qq{SELECT * FROM image});

for my $row (@$rows) {
    my $data = $rows->{data};
    my $digest = sha1_hex($data);
    my $idx  = index($row->{name}, ".");
    my $ext  = (0 <= $idx) ? substr($row->{name}, $idx) : "";
    my $fullpath = '/home/isucon/isubata/webapp/public/icons/' . $digest . $ext;
    print("$fullpath\n");

    open my $fh, '>', $fullpath;
    binmode $fh;
    print $fh $data;
    close($fh);
}

