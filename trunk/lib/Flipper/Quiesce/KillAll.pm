# Copyright (c) 2007-2008, Proven Scaling LLC
# 
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

package Flipper::Quiesce::KillAll;

use strict;
use Flipper::Quiesce;
use base qw( Flipper::Quiesce );

# TODO: This needs much more error checking.

# BIG WARNING:  the calling interface to this method WILL change in the future.  

sub before_ipdown
{
  my $self = shift;
  my $node_dbh = shift;

  # Save the current max_connections value for reinstatement later
  my ($max_connections) = $node_dbh->selectrow_array('SELECT @@max_connections');
  my $my_thread_id = $node_dbh->{'mysql_thread_id'};

  # Set max_connections to 1 to stop any more incoming connections - they'll get a "too many connections" error message
  $node_dbh->do('SET GLOBAL max_connections=1');

  my $max_delay = 10;
  my $elapsed_delay = 0;
  my $retry = 1;

  while ($elapsed_delay <= $max_delay && $retry)
  {
    print "DEBUG: KillAll attempt $elapsed_delay\n" if ($self->{debug});
    # Get SHOW PROCESSLIST into a hashref of hashrefs, keyed on thread ID
    my $processlist_sth = $node_dbh->prepare("SHOW FULL PROCESSLIST");
    $processlist_sth->execute();
    my $rhh_processlist = $processlist_sth->fetchall_hashref('Id');

    $retry = 0;
    foreach my $thread_id (keys %$rhh_processlist)
    {
      next if ($thread_id==$my_thread_id); # don't kill ourselves off
      if (defined $rhh_processlist->{$thread_id}->{Info}
          && $rhh_processlist->{$thread_id}->{Info} =~ /^\s*(\/\*.*?\*\/)?\s*(INSERT|UPDATE|DELETE|REPLACE|CREATE|DROP|ALTER|REPAIR|OPTIMIZE|ANALYZE|CHECK)/si) {
        if ($elapsed_delay < $max_delay)
        {
          # only want to leave the threads if we're not on our last retry
          print "DEBUG: Leaving thread ID $thread_id to complete\n" if ($self->{debug});
          $retry = 1;
          next;
        }
      }
      if ($rhh_processlist->{$thread_id}->{Command} =~ /(Query|Sleep)/)
      {
        print "DEBUG: Killing thread ID $thread_id\n" if ($self->{debug});
        $node_dbh->do("KILL $thread_id");
      }
    }
    sleep(1) if $elapsed_delay < $max_delay && $retry;
    $elapsed_delay++;
  }

  $node_dbh->do("SET GLOBAL max_connections=$max_connections");

  return 1;
}

1;
