require_relative "./plotter"
require_relative "./data_reader"

module KMeansClustering
  class Clusterer
    def initialize
      @data = DataReader.new("testSet.txt").read
    end

    def plot
      Plotter.new(columns).plot
    end

    def find_distances(centroid)
      distances = []
      @dataSet.rows.each do |row|
        sum = 0
        row.each_with_index do |el, i|
          sum += ((el - centroid[i])**2)
        end
        distances << sum**0.5
      end
      distances
    end

    def random_centroids(k)
      feature_size = @data.first.length
      centroids = []
      k.times do |i|
        centroids[i] = []
        feature_size.times do |j|
          mins ||= columns[j].min
          maxes ||= columns[j].max
          centroids[i][j] = mins + (maxes- mins) * (rand(10)/10.0)
        end
      end
      centroids
    end

    def columns
      x_coordinates, y_coordinates = [], []
      @data.each do |feature|
        x_coordinates << feature.first
        y_coordinates << feature.last
      end
      [x_coordinates, y_coordinates]
    end

  end
end

KMeansClustering::Clusterer.new.random_centroids(4)


