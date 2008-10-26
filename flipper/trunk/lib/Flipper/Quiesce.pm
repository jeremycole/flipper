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

package Flipper::Quiesce;

use strict;

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

# _after_new gets called by the new method.  allows extensions by subclasses.
sub _after_new
{
  my $self = shift;
  my $rh_params = shift;

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

# the following methods should be implemented by subclasses.

# before_ipdown is called before the IP is taken down.  typically this will be used for killing off connections.
sub before_ipdown
{
  my $self = shift;

  return;
}

# after_ipdown is called after the IP is taken down.  any cleaning up etc. can be done here.
sub after_ipdown
{
  my $self = shift;

  return;
}

1;
