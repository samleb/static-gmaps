require 'rubygems'
require 'spec'
require File.join(File.dirname(__FILE__), '..', 'lib', 'static_gmaps')
include StaticGmaps

STATIC_GOOGLE_MAP_DEFAULT_PARAMETERS_TEST_IMAGE_PATH = File.join File.dirname(__FILE__), 'test_image.gif'

describe StaticGmaps do
  describe Map, 'initialize with no attributes' do
    before(:each) do @map = StaticGmaps::Map.new end
    
    #it 'should set center to default'   do @map.center.should   == StaticGmaps::default_center end
    # no default center, because of auto adjustment
    it 'should set zoom to default'     do @map.zoom.should     == StaticGmaps::default_zoom end
    it 'should set size to default'     do @map.size.should     == StaticGmaps::default_size end
    it 'should set map_type to default' do @map.map_type.should == StaticGmaps::default_map_type end
  end
  
  describe Map, 'initialize with all attributes' do
    before(:each) do
      @marker = StaticGmaps::Marker.new :latitude => 0, :longitude => 0
      @map = StaticGmaps::Map.new :center   => [ 40.714728, -73.998672 ],
                                  :zoom     => 12,
                                  :size     => [ 500, 400 ],
                                  :map_type => :roadmap,
                                  :markers  => [ @marker ],
                                  :sensor   => true
    end

    it 'should have a url'   do @map.url.should      == 'http://maps.google.com/maps/api/staticmap?center=40.714728,-73.998672&map_type=roadmap&markers=0,0&sensor=true&size=500x400&zoom=12' end
    it 'should set center'   do @map.center.should   == [ 40.714728, -73.998672 ] end
    it 'should set zoom'     do @map.zoom.should     == 12 end
    it 'should set size'     do @map.size.should     == [ 500, 400 ] end
    it 'should set map_type' do @map.map_type.should == :roadmap end
    it 'should set markers'  do @map.markers.should  == [ @marker ] end
    it 'should set sensor'   do @map.sensor.should == true end
  end
  
  describe Map, 'with default attributes' do
    before(:each) do @map = StaticGmaps::Map.new end
    
    it 'should have a url'    do @map.url.should      == 'http://maps.google.com/maps/api/staticmap?center=0,0&map_type=roadmap&sensor=false&size=500x400&zoom=1' end
    it 'should have a width'  do @map.width.should    == 500 end
    it 'should have a height' do @map.height.should   == 400 end
    #it 'should respond to to_blob with an image' do @map.to_blob.should  == File.read(STATIC_GOOGLE_MAP_DEFAULT_PARAMETERS_TEST_IMAGE_PATH) end
  end
  
  describe Map, 'with default attributes and markers' do
    before(:each) do
      @marker_1 = StaticGmaps::Marker.new :latitude => 10, :longitude => 20, :color => 'green', :alpha_character => 'A'
      @marker_2 = StaticGmaps::Marker.new :latitude => 15, :longitude => 25, :color => 'blue', :alpha_character => 'B'
      @map = StaticGmaps::Map.new :markers  => [ @marker_1, @marker_2 ]
    end
    
    it 'should have a markers_url_fragment'              do @map.markers_url_fragment.should == 'color:green|label:a|10,20|color:blue|label:b|15,25' end
    it 'should include the markers_url_fragment its url' do @map.url.should include(@map.markers_url_fragment) end
  end
  
  describe Map, 'with center as a string address' do
    before(:each) do
      @map = StaticGmaps::Map.new :center => 'Montpellier, France'
    end
    
    it 'should use the escaped string as center' do @map.url.should == 'http://maps.google.com/maps/api/staticmap?center=Montpellier%2C+France&map_type=roadmap&sensor=false&size=500x400&zoom=1' end
  end
    
  describe Marker, 'initialize with no attributes' do
    before(:each) do @marker = StaticGmaps::Marker.new end
  
    it 'should set latitude to default'        do @marker.latitude.should        == StaticGmaps::default_latitude end
    it 'should set longitude to default'       do @marker.longitude.should       == StaticGmaps::default_longitude end
    it 'should set color to default'           do @marker.color.should           == StaticGmaps::default_color end
    it 'should set alpha_character to default' do @marker.alpha_character.should == StaticGmaps::default_alpha_character end
  end
  
  describe Marker, 'initialize with all attributes' do
    before(:each) do
      @marker = StaticGmaps::Marker.new :latitude => 12,
                                        :longitude => 34,
                                        :color => 'red',
                                        :alpha_character => 'z',
                                        :sensor => true
    end
    
    it 'should set latitude'        do @marker.latitude.should        == 12 end
    it 'should set longitude'       do @marker.longitude.should       == 34 end
    it 'should set color'           do @marker.color.should           == :red end
    it 'should set alpha_character' do @marker.alpha_character.should == :z end
  end
  
  describe Marker, 'with address attribute' do
    before(:each) do
      @marker = StaticGmaps::Marker.new(:color => 'blue', :address => 'Tasmania, Australia')
    end
    
    it 'should use the escaped string as location' do @marker.url_fragment.should == 'color:blue|Tasmania%2C+Australia' end
  end
end