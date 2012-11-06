require_relative "mergesort"
class Assignment3
  
  include Enumerable
  include MergeSort
  
  def initialize()
    @collection = [1,8,2,5,9,2,12, 4, 7]
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
  
  def splice(a,b)
    @collection[a..b]
  end
  
  def each(*args, &block)
    @collection.each(*args) do
      block.call
    end
  end
  
end