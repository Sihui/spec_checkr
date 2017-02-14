require "spec_checkr/version"

class SpecCheckr
  def initialize(target, spec_folder)
    @target = target
    @spec_folder = spec_folder
  end

  def check
    @files_in_target = get_files(@target)
    @files_in_spec = get_files(@spec_folder)
    print(@files_in_spec)
    compare_arrays
  end

  def get_files(directory)
    begin
      Dir.entries(directory).select { |f| !File.directory? f }
    rescue Errno::ENOENT
      print 'Directory not found'
    end
  end

  def compare_arrays
    return unless @files_in_target && @files_in_spec
    @files_in_target.reject do |f|
      sp = f.split('.')
      name = sp.first+'_spec'+sp[1]
      @files_in_spec.include?(name)
    end
  end
end
