require "rails_helper"

RSpec.describe User do
  subject { build(:user, password: "password") }

  describe "#validations" do
    it "validates the presence of a username" do
      subject.username = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:username]).to_not be_empty

      subject.username = ""
      expect(subject).to_not be_valid
      expect(subject.errors[:username]).to_not be_empty
    end

    it "is valid" do
      expect(subject).to be_valid
    end
  end

  describe "#authenticate" do
    context "when the password is correct" do
      it "returns true" do
        expect(subject.authenticate("password")).to be_truthy
      end
    end

    context "when the password is incorrect" do
      it "returns false" do
        expect(subject.authenticate("wrong")).to be_falsey
      end
    end
  end
end
