class BinaryMinHeap
  attr_reader :store, :prc

  def initialize(&prc)
    @store = []

    @prc = prc || Proc.new { |x, y| x <=> y }
  end

  def count
    @store.length
  end

  def extract
    @store[0], @store[-1] = @store[-1], @store[0]
    result = @store.pop
    BinaryMinHeap.heapify_down(@store, 0, @store.length, &prc)
    result
  end

  def peek
    @store[0];
  end

  def push(val)
    @store.push(val)
    @store = BinaryMinHeap.heapify_up(@store, @store.length - 1, @store.length, &@prc)
  end

  def self.has_invalid_child?(array, parent_index, child_indices, prc)
    return false unless child_indices.length > 0
    child_indices.each do |child_idx|
      return true if prc.call(array[parent_index], array[child_idx]) === 1
    end
    return false
  end

  def self.swap_with_child(array, parent_index, child_indices, prc)
    if child_indices.length == 2
      child_idx = prc.call(array[child_indices[0]], array[child_indices[1]]) < 1 ? child_indices[0] : child_indices[1]
    else
      child_idx = child_indices[0]
    end

    array[parent_index], array[child_idx] = array[child_idx], array[parent_index]
    child_idx
  end

  public
  def self.child_indices(len, parent_index)
    if (2 * parent_index) + 2 < len
      [(2 * parent_index) + 1, (2 * parent_index) + 2]
    elsif (2 * parent_index) + 1 < len
      [(2 * parent_index) + 1]
    else
      []
    end
  end

  def self.parent_index(child_index)
    raise "root has no parent" if child_index === 0
    (child_index - 1) / 2
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    prc ||= Proc.new { |x, y| x <=> y }
    child_indices = BinaryMinHeap.child_indices(len, parent_idx)
    if BinaryMinHeap.has_invalid_child?(array, parent_idx, child_indices, prc)
      new_idx = BinaryMinHeap.swap_with_child(array, parent_idx, child_indices, prc)
      BinaryMinHeap.heapify_down(array, new_idx, len, &prc)
    else
      array
    end
  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    prc ||= Proc.new { |x, y| x <=> y }
    parent_idx = child_idx > 0 ? BinaryMinHeap.parent_index(child_idx) : 0
    if prc.call(array[child_idx], array[parent_idx]) < 0 && child_idx > 0
      array[child_idx], array[parent_idx] = array[parent_idx], array[child_idx]
      BinaryMinHeap.heapify_up(array, parent_idx, len, &prc)
    else
      array
    end
  end
end
