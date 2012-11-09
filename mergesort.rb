require_relative("./contracts/mergesort_contracts.rb")
require "monitor"

# ECE 421 - Assignment #3
# Group 1
# Author:: Kenneth Rodas (krodas@ualberta.ca)
# Author:: Raymond Wainman (wainman@uablerta.ca)
# Author:: Dustin Durand (dddurand@ualberta.ca)

# Include this module with your collection to inherit the
# parallel merge sort capability. To sort, simply call sort!

module MergeSort

  include MergesortContracts
  # sorts the data structure, WARNING: modifies the current data structure
  def sort!(timeout = default_time(), &comparator)
    pre_sort!(timeout, &comparator)

    collection_start = 0
    collection_end = self.length - 1
    psort(collection_start, collection_end, &comparator)

    post_sort!(timeout, &comparator)
  end

  private

  def psort(collection_start, collection_end, &comparator)
    pre_psort(collection_start, collection_end, &comparator)

    collection_mid = ((collection_start+collection_end)/2).floor()

    if(collection_start < collection_end)
      left = Thread.new do
        psort(collection_start, collection_mid, &comparator)
      end

      right = Thread.new do
        psort(collection_mid+1, collection_end, &comparator)
      end

      left.join()
      right.join()

      pmerge(self, collection_start, collection_mid, collection_mid+1,
      collection_end, collection_start, collection_end, &comparator)
    end

    post_psort(self, collection_start, collection_end, &comparator)
  end

  @@NO_POSITION_FOUND=-1

  def binary_search(a, b, center, &comparator)
    pre_binary_search(a, b, center, &comparator)
    min = 0
    max = b.length-2

    result = @@NO_POSITION_FOUND

    if(b.length == 1)
      result = @@NO_POSITION_FOUND
      max = min - 1
    end

    while (max >= min)
      mid = ((min+max)/2).floor

      if(comparator.call(b[mid],center) == 1)
        max = mid - 1;
      elsif (comparator.call(b[mid+1],center)==-1)
        min = mid + 1;
      else
        result = mid;
        break;
      end
    end

    post_binary_search(a, b, center, result)
    return result
  end

  def merge(collection, left, right, p, r, &comparator)
    pre_merge(collection, left, right, p, r, &comparator)

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
        compare = comparator.call(left[0],right[0])
        if compare == -1
          a = left.shift
        elsif(compare >= 0)
          a = right.shift
        end
        collection[i] = a
      end
    end

    post_merge(collection, left, right, p, r, &comparator)
  end

  def pmerge(collection, a_start, a_end, b_start, b_end, p, r, &comparator)
    pre_pmerge(collection, a_start, a_end, b_start, b_end, p, r, &comparator)

    a_col,b_col = [], [];

    a_col = collection[a_start..a_end]
    b_col = collection[b_start..b_end]

    l = a_col.length-1
    m = b_col.length-1

    if(m > l)
      submerge = Thread.new do
        pmerge(collection, b_start, b_end, a_start, a_end, p, r, &comparator)
      end
      submerge.join()
    elsif(r == 0)
      collection[p] = a_col[0]
    elsif(l == 0)
      compare = comparator.call(a_col[0], b_col[0])
      if(compare <= 0)
        collection[p] = a_col[0]
        collection[r] = b_col[0]
      else
        collection[p] = b_col[0]
        collection[r] = a_col[0]
      end
    else
      a_mid = (l/2).floor

      position = @@NO_POSITION_FOUND
      position = binary_search(a_col, b_col, a_col[a_mid], &comparator)

      if(position == @@NO_POSITION_FOUND)
        merge(collection, a_col, b_col, p, r, &comparator)
        return
      end

      lastpos = (a_mid) + (position) + 1

      collection2 = collection.clone
      left = Thread.new do
        pmerge(collection2, a_start, a_start+a_mid, b_start, b_start+position, p, p+lastpos, &comparator)
      end

      collection3 = collection.clone
      right = Thread.new do
        pmerge(collection3, a_start+a_mid+1, a_end, b_start+position + 1, b_end, p+ lastpos + 1, r, &comparator)
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

    post_pmerge(collection, a_start, a_end, b_start, b_end, p, r, &comparator)
  end

  #Find a better relation to time: n*log(n)?
  # But threads will slow it down
  def default_time()
    if(self.length <= 0)
      return 1 * self.length * self.length
    end

    return self.length
  end
end
