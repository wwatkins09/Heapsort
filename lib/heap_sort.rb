require_relative "heap"

class Array
  def heap_sort!
    (0...self.length).each do |idx|
      BinaryMinHeap.heapify_up(self, idx, (idx + 1)) {|x, y| y<=>x}
    end
    (1..self.length).each do |counter|
      self[0], self[self.length - counter] = self[self.length - counter], self[0]
      BinaryMinHeap.heapify_down(self, 0, (self.length - counter)) {|x, y| y<=>x}
    end
  end
end
