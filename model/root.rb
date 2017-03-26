module Model
  class Root
    attr_reader :dataset

    def initialize(dataset)
      @dataset = dataset
    end
  end
end
