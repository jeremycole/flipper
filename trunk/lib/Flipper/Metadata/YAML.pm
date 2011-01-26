# Copyright (c) 2007-2011, Proven Scaling LLC and others
# Copyright (c) 2010-2011, Six Apart Ltd.
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

package Flipper::Metadata::YAML;

use strict;
use warnings;
use YAML qw( LoadFile );
use Flipper::Metadata;
use base qw( Flipper::Metadata );

sub _after_new
{
  my $self = shift;
  my $rh_params = shift;

  $self->{readonly} = 1;
  # stupid DSN parsing.
  my %dsn = ();
  my $dsn_line = $rh_params->{dsn};
  $dsn_line =~ s/^YAML://;
  for my $pair (split /;/, $dsn_line)
  {
    my ($name, $value) = split /=/, $pair;
    $dsn{$name} = $value;
  }
  die "must specify 'file' to load" unless $dsn{file};

  eval { $self->{_yaml} = LoadFile($dsn{file}) }
    or die "Failed to load yaml file '$dsn{file}': $!";

  return;
}

sub get_masterpair_info
{
  my $self = shift;
  my $masterpair = shift;
  return unless defined $masterpair;

  my $yaml = $self->{_yaml};
  if (defined $yaml->{$masterpair})
  {
    # applies global defaults to the master pair configuration.
    return { %{$yaml->{defaults}}, %{$yaml->{$masterpair}} };
  }
}

# NOTE: If nodes ever get more metadata than just 'ip', consider a
# node_defaults application similar to get_masterpair_info
sub get_node_info
{
  my $self = shift;
  my $masterpair = shift;
  my $node = shift;
  return unless defined $masterpair && defined $node;

  if (defined $self->{_yaml}->{$masterpair}->{nodes}->{$node})
  {
    return $self->{_yaml}->{$masterpair}->{nodes}->{$node};
  }
}

sub get_node_names
{
  my $self = shift;
  my $masterpair = shift;
  return unless defined $masterpair;

  my $nodes = $self->{_yaml}->{$masterpair}->{nodes};
  return [sort keys %$nodes];
}

sub get_masterpair_names
{
  my $self = shift;
  # Need to get a little weird to prevent 'defaults' from showing up.
  return [grep { $_ ne 'defaults' } sort keys %{$self->{_yaml}}];
}

1;
