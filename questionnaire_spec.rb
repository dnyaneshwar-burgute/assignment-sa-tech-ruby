require_relative 'questionnaire'

RSpec.describe "Questionnaire" do
  before do
    @store = PStore.new('test.store')
  end

  describe "#do_prompt" do
    let(:fake_input) { StringIO.new("yes\nno\nyes\n\nyes\n") }

    before do
      allow_any_instance_of(Kernel).to receive(:gets).and_return(fake_input.gets)
    end

    it "should prompt user for answers to all questions" do
      expect { do_prompt }.to output(/Can you code in Ruby?/).to_stdout
      expect { do_prompt }.to output(/Can you code in JavaScript?/).to_stdout
      expect { do_prompt }.to output(/Can you code in Swift?/).to_stdout
      expect { do_prompt }.to output(/Can you code in Java?/).to_stdout
      expect { do_prompt }.to output(/Can you code in C#?/).to_stdout
    end

    it "should store answers in the PStore" do
      do_prompt
      answers = nil
      @store.transaction(true) { answers = @store[:answers] }
      expect(answers).not_to be_nil
    end
  end

  describe "#do_report" do
    before do
      @store.transaction { @store[:answers] = {"q1"=>"yes", "q2"=>"no", "q3"=>"yes", "q4"=>"no", "q5"=>"yes"} }
    end

    it "should generate report with correct rating" do
      expect { do_report }.to output(/Rating for this run: 60.0%/).to_stdout
    end
  end
end
