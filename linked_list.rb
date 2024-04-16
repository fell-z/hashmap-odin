# Linked list Implementation
class LinkedList
  attr_reader :head, :tail

  # Contains key-value pair and a link to the next Node object
  class Node
    attr_accessor :pair, :next_node

    def initialize(pair = nil, next_node = nil)
      @pair = pair
      @next_node = next_node
    end
  end

  def initialize(head = nil, second = nil, *rest)
    @head = head.nil? ? nil : Node.new(head)
    @tail = second.nil? ? nil : Node.new(second)
    @head.next_node = @tail unless @head.nil?
    rest.each do |pair|
      append(pair)
    end
  end

  def get(key)
    at(find(key))
  end

  def append(pair)
    return fill_head(pair) if @head.nil?

    new_tail = Node.new(pair)
    if @tail.nil? || @tail == @head
      @head.next_node = new_tail
    else
      @tail.next_node = new_tail
    end
    @tail = new_tail
    pair
  end

  def update(key, new_value)
    node = at(find(key))

    node.pair[1] = new_value
  end

  def remove(key)
    index = find(key)

    prior_node = at(index - 1)
    removed_node_pair = at(index).pair

    prior_node.next_node = at(index + 1)
    removed_node_pair[1]
  end

  def has?(key)
    current_node = @head
    length.times do
      break if current_node.pair[0] == key

      current_node = current_node.next_node
    end
    current_node.pair[0] == key
  rescue StandardError
    false
  end

  def find(key)
    current_node = @head
    index = length.times do |time|
      break time if current_node.pair[0] == key

      current_node = current_node.next_node
    end
    (current_node.pair[0] == key) ? index : nil
  rescue StandardError
    nil
  end

  def at(index)
    current_node = @head
    index.times do
      current_node = current_node.next_node
    end
    current_node
  rescue StandardError
    nil
  end

  def keys
    keys_arr = []

    current_node = @head
    length.times do
      keys_arr << current_node.pair[0]

      current_node = current_node.next_node
    end

    keys_arr
  end

  def values
    values_arr = []

    current_node = @head
    length.times do
      values_arr << current_node.pair[1]

      current_node = current_node.next_node
    end

    values_arr
  end

  def pairs
    pairs_arr = []

    current_node = @head
    length.times do
      pairs_arr << current_node.pair

      current_node = current_node.next_node
    end

    pairs_arr
  end

  def length
    calc_length
  end

  private

  def fill_head(pair)
    @head = Node.new(pair, @tail)
    pair
  end

  def calc_length(root = @head)
    return 0 if root.nil?

    1 + calc_length(root.next_node)
  end
end
