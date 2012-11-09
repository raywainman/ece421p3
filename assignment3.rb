require_relative "mergesort"

# ECE 421 - Assignment #3
# Group 1
# Author:: Kenneth Rodas (krodas@ualberta.ca)
# Author:: Raymond Wainman (wainman@uablerta.ca)
# Author:: Dustin Durand (dddurand@ualberta.ca)

# This file defines a generic collection (that is needed because our
# merge sort is implemented as a module). In the constructor of this
# collection, we randomly populate an array of size x and sort them
# using our sorting algorithm. We sort it once using the default comparator
# and a second time using a custom comparator.

# To use this file simply use:
# ruby assignment3.rb

class SomeCollection

  include Enumerable
  # Include our algorithm module
  include MergeSort
  def initialize(x)
    @collection = []

    puts "Generating 1000 random elements..."
    for j in 0..1000 do
      @collection << (1 + rand(1000000)).to_i
    end

    control = self.clone

    puts "Sorting the random elements using default comparator..."
    self.sort!(1) { |i, j| i <=> j  }

    puts "Checking against control"
    control = control.sort(){ |i, j| i <=> j }
    if(control.to_a != self.to_a)
      raise "Error: Sort Doesn't match default sort.."
    else
      puts "Check Passed"
    end

    puts "Sorting the random elements using custom comparator..."
    self.sort!() { |i, j| j <=> i  }

    puts "Checking against control"
    control = control.sort(){ |i, j| j <=> i }
    if(control.to_a != self.to_a)
      raise "Error: Sort Doesn't match default sort.."
    else
      puts "Check Passed"
    end
    
    puts "Finished"
  end

  def [](i)
    @collection[i]
  end

  def []=(i,j)
    @collection[i]=j
  end

  def length
    @collection.length
  end

  def clone
    @collection.clone
  end

  def each(*args, &block)
    @collection.each(*args) do |i|
      block.call(i)
    end
  end

  def to_s
    @collection.to_s
  end

  alias each_index each_with_index

end

SomeCollection.new(1000)
exit! # To avoid TestUnit output