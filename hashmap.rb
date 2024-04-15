# Implementation of a hashmap
class HashMap
  def initialize
    @buckets = Array.new(16) { nil }
  end

  def set(key, value)
    index = index_from_key(key)

    verify_index(index)

    @buckets[index] = [key, value]
  end

  def get(key)
    return nil unless has?(key)

    index = index_from_key(key)

    verify_index(index)

    pair_retrieved = @buckets[index]

    pair_retrieved[1] if pair_retrieved[0] == key
  end

  def remove(key)
    return nil unless has?(key)

    index = index_from_key(key)

    verify_index(index)

    value_retrieved = @buckets[index][1]

    @buckets.delete_at(index)

    value_retrieved
  end

  def length
    @buckets.compact.size
  end

  def clear
    @buckets.map! { nil }
  end

  def has?(key)
    index = index_from_key(key)

    verify_index(index)

    pair_retrieved = @buckets[index]

    return false if pair_retrieved.nil?

    pair_retrieved[0] == key
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

  private

  def index_from_key(key)
    hash(key) % capacity
  end

  def verify_index(index)
    raise IndexError if index.negative? || index >= capacity
  end
end
