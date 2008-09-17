package Flipper::Quiesce::KillAll;

use strict;
use Flipper::Quiesce;
use base qw( Flipper::Quiesce );

# BIG WARNING:  the calling interface to this method WILL change in the future.  

sub before_ipdown {
	my $self = shift;
	my $node_dbh = shift;
	# Save the current max_connections value for reinstatement later
	my ($max_connections) = $node_dbh->selectrow_array('SELECT @@max_connections');
	my $my_thread_id = $node_dbh->{'mysql_thread_id'};
	# Set max_connections to 1 to stop any more incoming connections - they'll get a "too many connections" error message
	$node_dbh->do('SET GLOBAL max_connections=1');
	my $max_delay = 10;
	my $elapsed_delay = 0;
	while ($elapsed_delay <= $max_delay) {
		my $processlist_sth = $node_dbh->prepare("SHOW FULL PROCESSLIST");
		$processlist_sth->execute();
		my $rhh_processlist = $processlist_sth->fetchall_hashref('Id');
		foreach my $thread_id (keys %$rhh_processlist) {
			next if ($thread_id==$my_thread_id); # don't kill ourselves off
			next if ($rhh_processlist->{$thread_id}->{Info}=~/^\s*(\/\*.*?\*\/)?\s*(INSERT|UPDATE|DELETE)/si and $elapsed_delay < $max_delay);
			$node_dbh->("KILL $thread_id");
		}
		sleep(1) if $elapsed_delay < $max_delay;
		$elapsed_delay++;
	}
	$dbh->do("SET GLOBAL max_connections=$max_connections");
	return 1;
}
