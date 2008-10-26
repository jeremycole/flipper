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

package Flipper::Metadata::DBI;

use strict;
use Flipper::Metadata;
use base qw( Flipper::Metadata );

sub _after_new
{
  my $self = shift;
  my $rh_params = shift;

  $self->{readonly} = 1;  # this module is read only for now
  $self->{DBH} = DBI->connect(
    $rh_params->{dsn},
    $rh_params->{username},
    $rh_params->{password},
    { PrintError => 0, RaiseError => 0 }
  ) || die <<CONNECT_FAIL;
Couldn't connect using username '$rh_params->{username}' to DSN:
$rh_params->{dsn}

The error from DBI was:
$DBI::errstr

Check that the DSN, username and password specified in my.cnf or as options
to this script are all correct.
CONNECT_FAIL

  return;
}

sub get_masterpair_info
{
  my $self = shift;
  my $masterpair = shift;

  if (defined $masterpair)
  {
    if (!defined $self->{_cache}->{$masterpair}->{masterpair_info})
    {
      my $rah_masterpair_info = $self->{DBH}->selectall_arrayref(
        'SELECT name, value FROM masterpair WHERE masterpair=? ORDER BY name',
        { Slice => {} },
        $masterpair
      );
      if (defined $rah_masterpair_info && @$rah_masterpair_info)
      {
        my %h = map { $_->{name} => $_->{value} } @$rah_masterpair_info;
        $self->{_cache}->{$masterpair}->{masterpair_info} = \%h;
      }
    }
    return $self->{_cache}->{$masterpair}->{masterpair_info};
  } else {
    return;
  }
}

sub get_node_info
{
  my $self = shift;
  my $masterpair = shift;
  my $node = shift;

  if (defined $masterpair && defined $node)
  {
    if (!defined $self->{_cache}->{$masterpair}->{nodes_info}->{$node})
    {
      my $rah_node_info = $self->{DBH}->selectall_arrayref(
        'SELECT name, value FROM node WHERE masterpair=? AND node=? ORDER BY name',
        { Slice => {} },
        $masterpair,
        $node,
      );
      if (defined $rah_node_info && @$rah_node_info)
      {
        my %h = map { $_->{name} => $_->{value} } @$rah_node_info;
        $self->{_cache}->{$masterpair}->{nodes_info}->{$node} = \%h;
      }
    }
    return $self->{_cache}->{$masterpair}->{nodes_info}->{$node};
  } else {
    return;
  }
}

sub get_node_names
{
  my $self = shift;
  my $masterpair = shift;

  if (defined $masterpair)
  {
    if (!defined $self->{_cache}->{$masterpair}->{node_names})
    {
      my $rah_nodes = $self->{DBH}->selectall_arrayref(
        'SELECT DISTINCT node FROM node WHERE masterpair=? ORDER BY node',
        { Slice => {} },
        $masterpair,
      );
      if (defined $rah_nodes && @$rah_nodes)
      {
        my @nodes = map($_->{node}, @$rah_nodes);
        $self->{_cache}->{$masterpair}->{node_names} = \@nodes;
      }
    }
    return $self->{_cache}->{$masterpair}->{node_names};
  } else {
    return;
  }
}

sub get_masterpair_names
{
  my $self = shift;
  if (!defined $self->{_cache}->{_masterpairs}) {
    my $rah_masterpairs = $self->{DBH}->selectall_arrayref(
      'SELECT DISTINCT masterpair FROM masterpair ORDER BY masterpair',
      { Slice => {} },
    );
    if (defined $rah_masterpairs && @$rah_masterpairs)
    {
      my @masterpairs = map($_->{masterpair}, @$rah_masterpairs);
      $self->{_cache}->{_masterpairs} = \@masterpairs;
    }
  }

  return $self->{_cache}->{_masterpairs};
}

1;
