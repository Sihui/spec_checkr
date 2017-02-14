require "spec_helper"
require 'stringio'

RSpec.describe SpecCheckr do

  subject { SpecCheckr.new(directory, spec_folder)}
  let(:directory) { '/Users/sihui.huang/hack_night/spec_checkr/lib/spec_checkr' }
  let(:spec_folder) { '/Users/sihui.huang/hack_night/spec_checkr/spec_checkr' }
  let(:files) { subject.get_files(directory) }
  let(:spec_files) { subject.get_files(spec_folder) }
  let(:missing_specs) { subject.check }
  it "has a version number" do
    expect(SpecCheckr::VERSION).not_to be nil
  end

  context 'when the target directory exists' do
    before { Dir.mkdir 'spec_checkr'; File.new('spec_checkr/file.rb', 'w') }
    it 'gets a list of all the file names under the target directory' do
      expect(files.size).to eq 1
      expect(files[0]).to eq 'version.rb'
    end

    context 'when the corresponding directory does not exist under the spec folder' do
      it 'returns the list of filenames as missing specs' do
        expect(missing_specs.size).to eq 1
        expect(missing_specs[0]).to eq 'version.rb'
      end
    end

    context 'when the corresponding directory exists under the spec folder' do
      it 'gets a list of all the file names under the spec directory' do
        expect(spec_files.size).to eq 1
        expect(spec_files[0]).to eq 'file.rb'
      end

      it 'compares and return the diff of two lists of file names' do
        expect(missing_specs.size).to eq 1
        expect(missing_specs[0]).to eq 'version.rb'
      end
    end
    after { File.delete('spec_checkr/file.rb'); Dir.rmdir 'spec_checkr' }
  end

  context 'when the target directory does not exist' do
    it 'throws error' do
      expect{ subject.get_files('iojfjiewio') }.to output('Directory not found').to_stdout
    end
  end
end
