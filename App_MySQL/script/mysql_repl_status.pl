#!/usr/bin/perl -w

# Use Modules
#
use warnings;
use strict;
use DBI;
use DBD::mysql;


# Receive Arguments or display Usage
if (@ARGV < 1  || @ARGV > 1) {
        print "Usage: mysql_repl_status.pl CHECK\n";
        print "CHECK can be 'iorun' - Slave IO Running, 'sqlrun' - Slave SQL Running, 'secbmaster' - Seconds behind Master\n";
        exit;
}

# VARIABLES
#
my $host = "localhost";
my $port = "3306";
my $user = "tribilyagent";
my $pass = "somepassword";
my $dsn = "dbi:mysql::$host:$port";
#$ENV{DBI_AUTOPROXY} = "host=$host;port=$port";

# DBI Connect
my $dbh = DBI->connect($dsn,$user,$pass,{ PrintError=>0, RaiseError=>1 }) || die "Error Connecting to Database: $DBI::errstr\n";

# Query
my $sth = $dbh->prepare("SHOW SLAVE STATUS;") || die "Query preparing failed: $DBI::errstr\n";

# Execute
$sth->execute() || die "Failed to execute query: $DBI::errstr\n";

# Fetch Result
my $result = $sth->fetchrow_hashref() || die "Failed to fetch data\n";

# Print all Values
#while (my ($key, $val) = each %$result) {
#        print "$key = $val\n";
#}
# Return values based on argument.
#
if ( $ARGV[0] eq "iorun" ) {
        if ( $result->{'Slave_IO_Running'} eq "Yes" ) {
                print "1"."\n";
        }
        else {
                print "0"."\n";
        }
}
elsif ( $ARGV[0] eq "sqlrun" ) {
        if ( $result->{'Slave_SQL_Running'} eq "Yes" ) {
                print "1"."\n";
        }
        else {
                print "0"."\n";
        }
}
elsif ( $ARGV[0] eq "secbmaster" ) {
        print $result->{'Seconds_Behind_Master'}."\n";
}
elsif ( $ARGV[0] eq "tribilyversion" ) {
 	printf "%1.1f\n", 1.1;
}
else {
        print "Usage: mysql_repl_status.pl CHECK\n";
        print "CHECK can be 'iorun' - Slave IO Running, 'sqlrun' - Slave SQL Running, 'secbmaster' - Seconds behind Master, 'tribilyversion' - Version of Tribily Monitoring script\n";
}


# DBI Disconnect
$sth->finish();
$dbh->disconnect || die "Failed to disconnect\n";
