require_relative("./contracts/sorting_thread_contracts.rb")

# ECE 421 - Assignment #3
# Group 1
# Author:: Kenneth Rodas (krodas@ualberta.ca)
# Author:: Raymond Wainman (wainman@uablerta.ca)
# Author:: Dustin Durand (dddurand@ualberta.ca)

# Extension of Thread class to include an identifier
# for each thread.

class SortingThread < Thread
  include SortingThreadContracts
  
  attr_reader :id
  
  def initialize(id, &block)
    super(&block)
    @id = id
  end
end