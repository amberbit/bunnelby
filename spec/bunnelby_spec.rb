require 'spec_helper'
require_relative './test_server'
require_relative './test_client'

describe Bunnelby do
  it 'has a version number' do
    expect(Bunnelby::VERSION).not_to be nil
  end

end

