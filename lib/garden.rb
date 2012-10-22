# All code (c) 2012, Christopher C. Lamb, 2012
# All rights reserved
#
# This is a facade of various classes that need to be 
# included  to run the simulation.  This references
# the three application areas, the application layer,
# the domain layer, and the utility layer.  These layers
# have their own similar files.
require_relative 'garden/application'
require_relative 'garden/domain'
require_relative 'garden/util'