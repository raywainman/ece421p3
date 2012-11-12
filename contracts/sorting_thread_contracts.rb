require 'test/unit'

# ECE 421 - Assignment #3
# Group 1
# Author:: Kenneth Rodas (krodas@ualberta.ca)
# Author:: Raymond Wainman (wainman@uablerta.ca)
# Author:: Dustin Durand (dddurand@ualberta.ca)

# Contracts for the SortingThread class
module SortingThreadContracts
  include Test::Unit::Assertions
  
  def initalize_preconditions(id, &block)
    assert id != nil
    assert &block != nil
  end
  
  def initialize_postconditions()
    assert @id != nil
  end
end