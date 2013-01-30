require 'spec_helper'

describe 'Spidering the site' do
  it 'successfully completes when run from the home page' do
    spider_from '/'
  end
end
