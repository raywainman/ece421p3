require_relative "mergesort"
class Assignment3
  
  include Enumerable
  include MergeSort
  
  def initialize(x) 
    @collection = []
    
    for i in 0..x do   
      
      puts "Sorting #{i}..."
          
     @collection.clear()                
      for j in 0..i do
        @collection << (1 + rand(1000000)).to_i
          end
    
        control = self.clone  

        self.sort!() { |i, j| i <=> j  }
         
        control = control.sort(){ |i, j| i <=> j }
          
       #puts "mysort: " + self.to_a.to_s
        #puts "sort: " + control.to_a.to_s
          
        if(control.to_a != self.to_a)
          raise "Sort Doesn't match default sort alg."
        end
          

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

Assignment3.new(1000)