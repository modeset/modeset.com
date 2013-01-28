require 'spec_helper'

describe 'Spidering the site' do

  it 'is succssful from the root page' do
    spider_from '/'
  end

end
