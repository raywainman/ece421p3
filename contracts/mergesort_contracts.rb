require 'test/unit'

module Mergesort_contracts
  
  include Test::Unit::Assertions
  
  def check_timeout(timeout)
    assert(!timeout.nil?, "Timeout cannot be a nil value")
    assert(timeout.respond_to?("to_i"), "Timeout must respond to to_i")
    assert(timeout.to_i > 0, "Cannot have a timeout less or equal to zero seconds")
  end
  
  def check_comparator(timeout)
    
    assert(!comparator.nil?, "Timeout cannot be a nil value")
    
     assert(comparator.respond_to?("compare"), "Timeout cannot be a nil value")
    if(comparator.is_a("DefaultComparator"))
      
      self.each() do |i|
        assert(!i.nil?, "elements cannot be nil")
        assert(i.respond_to?("<=>"), "Without a custom comparator, all elements must respond to <=>")
      end
      
    end
  end
  
  def check_collection(collection)
    assert(collection.respond_to?("[]"))
    assert(collection.respond_to?("length"))
    assert(collection.respond_to?("slice"))
    assert(collection.respond_to?("each"))
    assert(collection.respond_to?("each_index"))
  end
  
  def pre_sort(comparator, timeout)
    
    check_collection(self)
    check_timeout(timeout)
    check_comparator(comparator)

    
  end
  
  def post_sort(comparator, timeout)
        self.each_index() do |i|
          current_val = self[i]
          next_val = self[i+1]
          
          comparision = comparator.compare(current_val, next_val)
          assert(comparision <= 0, "Invalid sorting detected.")          
        end      
  end
  
  def common_conditions(astart, aend, bstart, bend, p, r)
    
    common_subcollection_a(astart, aend)
    common_subcollection_b(bstart, bend)
    common_subcollection(p, r)
    
    assert(astart >= p)
    assert(bstart >= p)
    
    assert(aend <= r)
    assert(bend <= r)
    
    #no overlap
    assert(bend < astart && aend < bstart)
    
    a_length = astart + aend + 1
    b_length = bstart + bend + 1
    collection_length = r + p + 1
    
    assert(a_length + b_length != collection_length, "Merge of length a & length b requires collection to have length a + b")  
  end
  
  def common_subcollection_a(astart, aend)
    assert(a_start <= a_end, "SubCollection A: end index larger than start index")
    assert(astart >= 0, "Index for start of sub collection a must be greater than 0")
  end
  
  def common_subcollection_b(bstart, bend)
    assert(bstart <= b_end, "SubCollection B: end index larger than start index")
    assert(bstart >= 0, "Index for start of sub collection b must be greater than 0")
  end
  
  def common_subcollection(p, r)
    assert(p <= r, "SubCollection: end index larger than start index")
    assert(p >= 0, "Index for start of sub collection must be greater than 0")
  end
  
  def check_order(p, r, comparator)  
    
    (p..r-1).each() do |i|
      current_val = self[i]
      next_val = self[i+1]
      
      comparision = comparator.compare(current_val, next_val)
      assert(comparision <= 0, "Invalid sorting detected.")
      
    end  
  end
  
    
  def pre_psort(astart, aend, bstart, bend, p, r, comparator)
    check_comparator(comparator)
    common_conditions(astart, aend, bstart, bend, p, r)
  end
  
  def post_psort(p, r, comparator)
    check_order(p, r, comparator)
  end

  def pre_binary_search(a, b, center, comparator)
    check_comparator(comparator)
    
    check_collection(b)
    
    assert(!center.nil?)
    
    assert(!comparator.nil?)
    assert(comparator.respond_to?("compare"))
    
    if(comparator.is_a("DefaultComparator"))
      assert(center.respond_to?("<=>"))
    end
  end
  
  def post_binary_search(a, b, center, result)
    assert(!result.nil?)
    assert(result == -1 || (result >= 0 and result <= b.length - 2))
  end

  def pre_merge(left, right, p, r, comparator)
    check_comparator(comparator)
    common_subcollection(p, r)
    
    check_collection(left)
    check_collection(right)
    
    assert(left.length + right.length == (p+r+1))
  end
  
  def post_merge(left, right, p, r, comparator)
    check_order(p, r, comparator)
  end

  def pre_pmerge(astart, aend, bstart, bend, p, r, comparator)
    common_conditions(astart, aend, bstart, bend, p, r)
    check_comparator(comparator)
  end
  
  def post_pmerge(astart, aend, bstart, bend, p, r, comparator)
    check_order(p, r, comparator)
  end
  
end