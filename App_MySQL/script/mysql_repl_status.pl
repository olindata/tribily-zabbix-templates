#!/usr/bin/perl -w

# Use Modules
#
use warnings;
use strict;
use DBI;
use DBD::mysql;

# VARIABLES
#
my $host = "192.168.1.6";
my $port = "3306";
my $user = "root";
my $pass = "iforgotit";
my $dsn = "dbi:mysql:zabbix:$host:$port";
#$ENV{DBI_AUTOPROXY} = "host=$host;port=$port";

# DBI Connect
my $dbh = DBI->connect($dsn,$user,$pass,{ PrintError=>0, RaiseError=>1 }) || die "Error Connecting to Database: $DBI::errstr\n";

# Query
my $sth = $dbh->prepare("show databases;") || die "Query preparing failed: $DBI::errstr\n";

# Execute
$sth->execute() || die "Failed to execute query: $DBI::errstr\n";

# Fetch Result
my $result = $sth->fetchrow_hashref() || die "Failed to fetch data\n";

# Print all Values
while (my ($key, $val) = each %$result) {
	print "$key = $val\n";
}



# DBI Disconnect
$sth->finish();
$dbh->disconnect || die "Failed to disconnect\n";

