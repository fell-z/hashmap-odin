require_relative "./linked_list"

# Implementation of a hashmap
class HashMap
  LOAD_FACTOR = 0.75

  def initialize
    @buckets = Array.new(16) { nil }
  end

  def has?(key)
    index = index_from_key(key)

    pair_retrieved = @buckets[index]

    return pair_retrieved.has?(key) if pair_retrieved.is_a?(LinkedList)

    return false if pair_retrieved.nil?

    pair_retrieved[0] == key
  end

  def set(key, value)
    index = index_from_key(key)

    grow if grow?

    pair_retrieved = @buckets[index]

    if pair_retrieved.is_a?(LinkedList)
      return pair_retrieved.update(key, value) if pair_retrieved.has?(key)

      return pair_retrieved.append([key, value])
    end

    if pair_retrieved.nil? || pair_retrieved[0] == key
      @buckets[index] = [key, value]
    elsif pair_retrieved[0] != key
      @buckets[index] = LinkedList.new(pair_retrieved, [key, value])
    end
  end

  def get(key)
    return nil unless has?(key)

    index = index_from_key(key)

    pair_retrieved = @buckets[index]

    return pair_retrieved.get(key) if pair_retrieved.is_a?(LinkedList)

    pair_retrieved[1]
  end

  def remove(key)
    index = index_from_key(key)

    pair_retrieved = @buckets[index]
    if pair_retrieved.is_a?(LinkedList)
      return nil unless pair_retrieved.has?(key)

      removed_value = pair_retrieved.remove(key)

      @buckets[index] = pair_retrieved.head.pair if pair_retrieved.length == 1

      return removed_value
    end

    return nil unless has?(key)

    @buckets[index] = nil

    pair_retrieved[1]
  end

  def length
    @buckets.compact.reduce(0) do |total, bucket|
      next total + bucket.length if bucket.is_a?(LinkedList)

      total + 1
    end
  end

  def clear
    @buckets.map! { nil }
  end

  def keys
    @buckets.compact.map do |bucket|
      next bucket.keys if bucket.is_a?(LinkedList)

      bucket[0]
    end.flatten
  end

  def values
    @buckets.compact.map do |bucket|
      next bucket.values if bucket.is_a?(LinkedList)

      bucket[1]
    end.flatten
  end

  def entries
    @buckets.compact.map do |bucket|
      next bucket.pairs if bucket.is_a?(LinkedList)

      [bucket]
    end.flatten(1)
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end

  def capacity
    @buckets.size
  end

  def grow?
    threshold = capacity * LOAD_FACTOR

    length >= threshold
  end

  def grow
    old_buckets = entries

    @buckets = Array.new(capacity * 2) { nil }

    old_buckets.each { |pair| set(pair[0], pair[1]) }
  end

  private

  def index_from_key(key)
    index = hash(key) % capacity
    verify_index(index)
    index
  end

  def verify_index(index)
    raise IndexError if index.negative? || index >= capacity
  end
end
