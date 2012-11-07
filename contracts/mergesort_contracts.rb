require 'test/unit'

module MergesortContracts

  include Test::Unit::Assertions
  def check_timeout(timeout)
    assert(!timeout.nil?, "Timeout cannot be a nil value")
    assert(timeout.respond_to?("to_i"), "Timeout must respond to to_i")
    assert(timeout.to_i > 0, "Cannot have a timeout less or equal to zero seconds")
  end

  def check_comparator_values(a, b, &comparator)
    test_value1 = a
    test_value2 = b
    result = comparator.call(test_value1,test_value2)
    assert(result == 0 || result == -1 || result == 1, "Comparision should only return -1, for less than, 0 for equal, or 1 for greater")

    result2 = comparator.call(test_value2,test_value1)

    if(result == -1)
      assert(result2 == 1, "Reversing order of values that produced -1 should have returned 1")
    elsif(result == 1)
      assert(result2 == -1, "Reversing order of values that produced 1 should have returned -1")
    else
      assert(comparator.call(a,a) == 0, "Comparision block must return 0 for the same element")
      assert(comparator.call(b,b) == 0, "Comparision block must return 0 for the same element")
    end

  end

  def check_comparator(&comparator)

    assert(block_given?, "Comparator block must be provided")
    assert(comparator.arity == 2, "Provided comparision block must take two parameters")

    if(self.length > 0)
      a = self[0]
      check_comparator_values(a, a, &comparator)
    end

    if(self.length > 1)
      test_value1 = self[0]
      test_value2 = self[1]
      check_comparator_values(test_value1, test_value2, &comparator)
    end

    if(self.length > 2)
      test_value1 = self[0]
      test_value2 = self[2]
      check_comparator_values(test_value1, test_value2, &comparator)

      test_value1 = self[1]
      test_value2 = self[2]
      check_comparator_values(test_value1, test_value2, &comparator)

    end

  end

  def check_collection(collection)
    assert(collection.respond_to?("[]"), "Object including mergesort module must respond to []")
    assert(collection.respond_to?("[]="), "Object including mergesort module must respond to []=")
    assert(collection.respond_to?("length"), "Object including mergesort module must respond to length")
    assert(collection.respond_to?("each"), "Object including mergesort module must respond to each")
    assert(collection.respond_to?("each_index"), "Object including mergesort module must respond to each_index")
  end

  def pre_sort!(timeout, &comparator)

    check_collection(self)
    check_timeout(timeout)
    check_comparator(&comparator)

  end

  def post_sort!(timeout, &comparator)
    self.each_with_index() do |item, index|
      
      if(index < self.length - 1)
        current_val = self[index]
        next_val = self[index+1]
      end

      comparision = comparator.call(current_val, next_val)
      assert(comparision <= 0, "Invalid sorting detected.")
    end
  end

  def common_conditions(a_start, a_end, b_start, b_end, p, r)

    common_subcollection_a(a_start, a_end)
    common_subcollection_b(b_start, b_end)
    common_subcollection(p, r)

    assert(a_start >= p)
    assert(b_start >= p)

    assert(a_end <= r)
    assert(b_end <= r)
    
    #no overlap -  e1 <= s2 or e2 <= s1
    assert(a_end <= b_start || b_end <= a_start, "No Overlap allowed between sub collections a & b")
    

    a_length = a_start + a_end + 1
    b_length = b_start + b_end + 1
    collection_length = r + p + 1

    assert(a_length + b_length != collection_length, "Merge of length a & length b requires collection to have length a + b")
  end

  def common_subcollection_a(a_start, a_end)
    assert(a_start <= a_end, "SubCollection A: end index larger than start index")
    assert(a_start >= 0, "Index for start of sub collection a must be greater than 0")
  end

  def common_subcollection_b(b_start, b_end)
    assert(b_start <= b_end, "SubCollection B: end index larger than start index")
    assert(b_start >= 0, "Index for start of sub collection b must be greater than 0")
  end

  def common_subcollection(p, r)
    assert(p <= r, "SubCollection: end index larger than start index")
    assert(p >= 0, "Index for start of sub collection must be greater than 0")
  end

  def check_order(p, r, &comparator)

    (p..r-1).each() do |i|
      current_val = self[i]
      next_val = self[i+1]

      comparision = comparator.call(current_val, next_val)
      assert(comparision <= 0, "Invalid sorting detected.")

    end
  end

  def pre_psort(p, r, &comparator)
    check_comparator(&comparator)
    common_subcollection(p, r)
  end

  def post_psort(p, r, &comparator)
    check_order(p, r, &comparator)
  end

  def pre_binary_search(a, b, center, &comparator)
    check_comparator(&comparator)

    check_collection(b)

    assert(!center.nil?)
  end

  def post_binary_search(a, b, center, result)
    assert(!result.nil?)
    assert(result == -1 || (result >= 0 and result <= b.length - 2), "Invalid Binary Result Detected")
  end

  def pre_merge(left, right, p, r, &comparator)
    check_comparator(&comparator)
    common_subcollection(p, r)

    check_collection(left)
    check_collection(right)
    
    assert((left.length + right.length) == (r-p+1), "Left #{left.length} and right #{right.length} subcollections must equal size of total collection #{p+r+1}")
  end

  def post_merge(left, right, p, r, &comparator)
    check_order(p, r, &comparator)
  end

  def pre_pmerge(collection,astart, aend, bstart, bend, p, r, &comparator)
    common_conditions(astart, aend, bstart, bend, p, r)
    check_comparator(&comparator)
  end

  def post_pmerge(collection,astart, aend, bstart, bend, p, r, &comparator)
    check_collection(collection)
    check_order(p, r, &comparator)
  end
  
  #Contracts for the normal merge sort. To be used when threaded merge fails.
  def pre_normal_merge(collection, left, right, p, r)
    #Type checking
    assert left.is_a?(Array), "Parameter 'left' not an array."
    assert right.is_a?(Array), "Parameter 'right' not an array."
    assert collection.is_a?(Array), "First parameter must be an array."
    assert p.is_a?(Fixnum), "Parameter p must be a number."
    assert r.is_a?(Fixnum), "Parameter r must be a number."
    #Method checking
    assert collection.respond_to?(:[]), "First parameter needs to be able to access its values."
    assert left.respond_to?(:[]), "Second parameter needs to be able to access its values."
    assert right.respond_to?(:[]), "Third parameter needs to be able to access its values."
    assert left.respond_to?(:shift), "Shift method needed for second parameter."
    assert right.respond_to?(:shift), "Shift method needed for third parameter."
    #Value checking
    assert p <= r, "Index conflict. Left index must be <= right index."
  end
  
  #Postconditions after using the "normal" merge sort
  def post_normal_merge(collection,left,right,p,r)
    #All values must be sorted according to the comparator
    (p..r-1).each { |i|
       assert comparator(collection[i],collection[i+1]), "Out-of-order values found in sorted section of the array after merging."
    }
  end
    
end