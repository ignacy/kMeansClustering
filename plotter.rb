require 'gchart'
require 'launchy'

module KMeansClustering
  class Plotter < Struct.new :data
    def plot
      Launchy.open(Gchart.scatter(:data => data, :size => '400x400', :theme => :keynote))
    end
  end
end

# KMeansClustering::Plotter.new([[1, 2, 3, 4, 5], [1, 2, 3, 4 ,5]]).plot
