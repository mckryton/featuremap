class Setup

  def initialize(pOutputFile)
    if pOutputFile == nil
      @OutputFile = "featuremap.mm"
    else
      @OutputFile = pOutputFile
    end
  end

end
