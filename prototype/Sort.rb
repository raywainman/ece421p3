require 'monitor'

#     PROOF OF CONCEPT / Alg.
# --Beware of ugly code :{ --
#
#

class Sort
  def initialize()

    @test = []
    @lock = Monitor.new

    #Power Sorting
    #Not for the faint of heart
    for i in 0..2000 do
    
      @test.clear
      
    for j in 0..i do
      @test << (1 + rand(1000000)).to_i
    end

    #Perform Sort
    merge_sort(@test, 0, @test.length-1)

    #Report Sorted
    puts "Sorted: " + @test.to_s

    #Sanity Check
    @test.each_index() do |k|

      if(k < @test.length - 1)
        currentval = @test[k]
        nextval = @test[k+1]

        if(currentval > nextval)
          raise "INCORRECTLY SORTED...@lock   T_T"
        end

      end
    end
    
    end

  end

  def merge_sort(collection, p, r)
    q = ((p+r)/2).floor()

    if(p < r)
      left = Thread.new do
        merge_sort(collection, p, q)
      end

      right = Thread.new do
        merge_sort(collection, q+1, r)
      end

      left.join()
      right.join()

      puts "Range: #{p}-#{q}-#{r}"

      merge(collection, p, q, q+1, r, p, r)

      #puts collection.to_s
       
      (p..r).each do |i|
      
            if(i < r - 1)
              currentval = collection[i]
              nextval = collection[i+1]
      
              if(currentval > nextval)
                puts collection[p..r].to_s
                raise "INCORRECTLY SORTED...@lock   T_T i: #{i} :: #{currentval} ,i: #{i+1} :: #{nextval} "
              end
      
            end
          end

    end
  end

  def merge(collection, a_start, a_end, b_start, b_end, p, r)

    if(a_start > a_end)
      raise "astart #{a_start} > aend #{a_end}";
    end

    if(b_start > b_end)
      raise "bstart #{b_start} > bend #{b_end}";
    end

    if(p > r)
      raise "r #{r} > p #{p}";
    end

    ##puts "i_astart"+a_start.to_s
    ##puts "i_aend: "+a_end.to_s

    a,b = [], [];
    @lock.synchronize do
      a = collection[a_start..a_end]
      b = collection[b_start..b_end]
    end

    l = a.length-1
    m = b.length-1

    if(a.length + b.length != (r - p + 1))
      raise "a.length #{a.length} b.length #{b.length} != collection #{r - p + 1}";
    end
    
    ##puts "astart: " + a_start.to_s
    ##puts "aend: " + a_end.to_s
    ##puts "bstart: " + b_start.to_s
    ##puts "bend: " + b_end.to_s
    ##puts "A: " + a.to_s
    #puts "B:" + b.to_s
    #puts "collection: " + collection.to_s

    #puts m
    #puts l

    if(m > l)
      submerge = Thread.new do
        merge(collection, b_start, b_end, a_start, a_end, p, r)
      end

      submerge.join()

    elsif(r == 0)
      @lock.synchronize do
        collection[p] = a[0]
      end
    elsif(l == 0)
      if(a[0] <= b[0])
        @lock.synchronize do
          collection[p] = a[0]
          collection[r] = b[0]
        end
      else
        @lock.synchronize do
          collection[p] = b[0]
          collection[r] = a[0]
        end
      end
    else
      a_mid = (l/2).floor
      #puts "amid-" + a_end.to_s

      position = binary_search(collection, a, b, a[a_mid])

      #puts "position: " + position.to_s
      
      if(position == -1)
        mergex(collection, a, b, p, r)
        return
      end

      #puts "a:" + a.to_s
      #puts "B:" + b.to_s
      
      #puts "astart:" +  a_start.to_s
      #puts "aend: #{a_start} #{a_mid}"
      
      #puts "bstart #{b_start}"
      #puts "bend #{b_start} #{position}"
      
      #puts "p #{p}"
      #puts "r #{p} #{a_mid}  #{position}"
      
      collection2 = collection.dup
      
      lastpos = (a_mid) + (position) + 1
      
      #FOUND THE DAMN RACE CONDITION -.-
      #This merge alg. is freaking weird...
      left = Thread.new do
        merge(collection2, a_start, a_start+a_mid, b_start, b_start+position, p, p+lastpos)
      end

      #puts a.to_s
      #puts b.to_s

      #puts a_start.to_s
      #puts a_mid.to_s

      
      #FOUND THE DAMN RACE CONDITION -.-
      #This merge alg. is freaking weird...
      collection3 = collection.dup
      
      
      right = Thread.new do
        merge(collection3, a_start+a_mid+1, a_end, b_start+position + 1, b_end, p+ lastpos + 1, r)
      end

      left.join()
      right.join()
      
      #Ugly hack to sync up dup collections to main one
      (p..p+ lastpos).each() do |i|
        collection[i] = collection2[i]
      end
      
      (p+ lastpos + 1..r).each() do |i|
        collection[i] = collection3[i]
      end

    end

  end

  def binary_search(collection, a, b, center)

    min = 0
    max = b.length-1

    ##puts "BS_Min: " + min.to_s
    ##puts "BS_MAX: " + max.to_s
    ##puts "BS_a: " + a.to_s
    ##puts "BS_b: " + b.to_s
    
    if(b.length == 1)
      return -1
    end
    

    while (max >= min)

      mid = ((min+max)/2).floor

      # #puts "mid: " + mid.to_s
      ## #puts "a_mid: " + a_mid.to_s

      #      #puts "a[mid]: "+ mid.to_s
      #            #puts "b[min]: "+ min.to_s
      #            #puts "b[max]: "+ max.to_s
      #
      #      #puts b.to_s
      #      #puts a.to_s
      
      
      if(mid+1 == b.length-1)
        return -1;
      end

      if(b[mid] > center)
        min = mid + 1;
      elsif (b[mid+1] < center)
        max = mid - 1;
      else

        # #puts "a[mid]: "+ a[mid].to_s
        # #puts "b[min]: "+ b[min].to_s
        # #puts "b[max]: "+ b[max].to_s

        return mid;
      end
    end

    return -1;
  end

end

def mergex(collection, left, right, p, r)

  puts "Normal Merge"

  #puts left.to_a
  #puts right.to_a
  
  (p..r).each() do |i|

    if(left.length == 0)
      a = right.shift
      collection[i] = a
      next
    elsif(right.length==0)
      a = left.shift
      collection[i] = a
      next
    else

      if left[0] < right[0]
        a = left.shift
      elsif(right[0] <= left[0])
        a = right.shift
      end

      #puts a
      #puts i
      #puts "collection_pre: " + collection.to_s
      collection[i] = a
      #puts "collection_post: " + collection.to_s

    end

  end

end

Sort.new()
