class PokeMessage
  attr_reader :fingerprint, :state

  def initialize(fingerprint:, state: )
    @fingerprint = fingerprint
    @state = state
  end

  def routing_key
    "commands.poke.#{fingerprint}"
  end

  def to_hash
    {
      fingerprint: fingerprint,
      state: state
    }
  end

  def to_json
    to_hash.to_json
  end
end
