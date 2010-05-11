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

package Flipper::Metadata;

use strict;

# this could probably be implemented using DBIx::Class for database access via DBI, making things much simpler
# but I don't want to limit us to DBI stuff only for metadata storage

sub new
{
  my $class = shift;
  my $rh_params = shift;

  my $self = bless {
    debug => 0,
    _cache => {},
  }, $class;
  $self->_after_new($rh_params);

  return $self;
}

# _after_new gets called by the new method.  allows subclasses to connect to databases etc.
# should set $self->{readonly} to 0 if the metadata subclass supports writing, for future expansion
sub _after_new
{
  my $self = shift;
  my $rh_params = shift;

  # sensible default - says the metadata module doesn't support writing
  $self->{readonly} = 1; 

  return;
}

# set_debug and get_debug control/read the debug flag
sub set_debug
{
  my $self = shift;
  my $debug = shift || 1;

  $self->{debug} = $debug;
}

sub get_debug
{
  my $self = shift;

  return $self->{debug};
}

# the following methods should be implemented by subclasses.  what follows is solely a prototype.

# get_masterpair_info returns a reference to a hash, keys and values being the details for the current masterpair.
# should return nothing if no masterpair specified, or the given masterpair doesn't exist in the metadata (ie. no key/value rows for that masterpair)
sub get_masterpair_info
{
  my $self = shift;
  my $masterpair = shift;

  if (defined $masterpair)
  {
    if (!defined $self->{_cache}->{$masterpair}->{masterpair_info})
    {
      # we don't have it in the cache, so get the information and populate the cache
      if ($masterpair eq 'mike')
      {
        # we can only populate the cache if the masterpair exists
        $self->{_cache}->{$masterpair}->{masterpair_info} = {
          'read_ip'  => '10.6.0.66',
          'write_ip'  => '10.6.0.67',
          'netmask'  => '255.255.255.0',
          'broadcast'  => '10.6.0.255',
        };
      }
    }
    # we have retrieved this information, either on this call to the method or a previous one,
    # so return the information from the cache
    return $self->{_cache}->{$masterpair}->{masterpair_info};
  } else {
    # no masterpair defined, so return nothing
    return;
  }
}

# get_nodes_info returns a reference to a hash, keys are the node names, values are hashrefs of key/value information.
# should return nothing if no masterpair specified, the given masterpair doesn't exist in the metadata, or no nodes exist for the masterpair.
# this probably doesn't need to be reimplemented by subclasses - no data access happens here
sub get_nodes_info
{
  my $self = shift;
  my $masterpair = shift;

  if (defined $masterpair)
  {
    if (!defined $self->{_cache}->{$masterpair}->{nodes_info})
    {
      # we don't have this information in the cache already, so get the information and populate the cache
      my $nodes_arrayref = $self->get_node_names($masterpair);
      if (defined $nodes_arrayref && @$nodes_arrayref)
      {
        foreach my $node (@$nodes_arrayref)
        {
          # call this without caring about the return value, as the cache will be
          # populated, and we're going to return that.
          $self->{_cache}->{$masterpair}->{nodes_info}->{$node} = $self->get_node_info($masterpair, $node);
        }
      }
    }
    # return the contents of the cache
    return $self->{_cache}->{$masterpair}->{nodes_info};
  } else {
    # no masterpair specified, so return nothing
    return;
  }
}

# get_node_info returns a reference to a hash of key/value info pairs.
# should return nothing if masterpair and node are not specified.  should return nothing if the masterpair and node don't exist in the metadata.
sub get_node_info
{
  my $self = shift;
  my $masterpair = shift;
  my $node = shift;

  if (defined $masterpair && defined $node)
  {
    if (!defined $self->{_cache}->{$masterpair}->{nodes_info}->{$node})
    {
      # we don't have this information in the cache already, so get the information and populate the cache
      if ($node eq 'first_node')
      {
        $self->{_cache}->{$masterpair}->{nodes_info}->{$node} = {
          'ip' => '10.6.0.64'
        };
      } else {
        $self->{_cache}->{$masterpair}->{nodes_info}->{$node} = {
          'ip' => '10.6.0.65'
        };
      }
    }
    return $self->{_cache}->{$masterpair}->{nodes_info}->{$node};;
  } else {
    # the masterpair and/or the node wasn't specified, so return undef
    return;
  }
}

# get_node_names should return a reference to an array of node names for the given masterpair
# should return undef if the masterpair isn't specified, doesn't exist, or doesn't have any nodes.
sub get_node_names
{
  my $self = shift;
  my $masterpair = shift;

  if (defined $masterpair)
  {
    if (!defined $self->{_cache}->{$masterpair}->{node_names})
    {
      # this information isn't in the cache, so get the information and populate the cache
      $self->{_cache}->{$masterpair}->{node_names} = [
        'first_node',
        'second_node'
      ];
    }
    return $self->{_cache}->{$masterpair}->{node_names};
  } else {
    # no masterpair specified, so return nothing
    return;
  }
}

# get_masterpair_names should return reference to an array of masterpair names
# should return (preferably) undef or reference to an empty array if no masterpairs exist
sub get_masterpair_names
{
  my $self = shift;

  if (!defined $self->{_cache}->{_masterpairs})
  {
    $self->{_cache}->{_masterpairs} = [ 'mike' ];
  }

  return $self->{_cache}->{_masterpairs};
}

1;
