require_relative "mergesort"
class Assignment3
  
  include Enumerable
  include MergeSort
  
  def initialize(x) 
    @collection = []
    
    for i in 0..x do       
     @collection.clear()                
      for j in 0..i do
        @collection << (1 + rand(1000000)).to_i
          end
    
        control = self.dup  
        puts self.to_s
        self.sort!() { |i, j| i <=> j  }
         
        control.sort(){ i <=> j }
          
        if(control.to_a != self.to_a)
          raise "Sort Doesn't match default sort alg."
        end
          
       puts self.to_s
     end   

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

Assignment3.new(25)