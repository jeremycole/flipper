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

package Flipper::Metadata::CSV;

use strict;
use Flipper::Metadata;
use base qw( Flipper::Metadata );

sub _after_new
{
  my $self = shift;
  my $rh_params = shift;
  my ($dir) = ($rh_params->{dsn} =~ /dir=(.*)/);
  my $masterpairFile = "$dir/masterpair";
  my $nodeFile = "$dir/node";
  -f $masterpairFile or die "No masterpair file: $masterpairFile";
  -f $nodeFile or die "No node file: $nodeFile";
  open FH, $nodeFile or die "Couldn't open $nodeFile";
  <FH>;
  my $nodes = {};
  $self->{nodes} = $nodes;
  while (my $line = <FH>)
  {
    chomp $line;
    my ($masterpair,$node,$name,$value) = split ",", $line; 
    $nodes->{$masterpair}{$node}{$name} = $value;
  }
  close FH;
  open FH, $masterpairFile or die "Couldn't open $masterpairFile";
  <FH>;
  my $masterpairs = {};
  $self->{masterpairs} = $masterpairs;
  while (my $line = <FH>)
  {
    chomp $line;
    my ($masterpair,$name,$value) = split ",", $line; 
    $masterpairs->{$masterpair}{$name} = $value;
  }

  

  return;
}

sub get_masterpair_info
{
  my $self = shift;
  my $masterpair = shift;

  return $self->{masterpairs}{$masterpair};
  
}

sub get_node_info
{
  my $self = shift;
  my $masterpair = shift;
  my $node = shift;

  return $self->{nodes}{$masterpair}{$node};
}

sub get_node_names
{
  my $self = shift;
  my $masterpair = shift;
  
  return [keys %{$self->{nodes}{$masterpair}}];

}

sub get_masterpair_names
{
  my $self = shift;
  return [keys %{$self->{masterpairs}}];
}

1;

