require "spec_helper"

RSpec.describe NotOnUpdate, type: :model do
  describe "#touch_with_version", versioning: true do
    let!(:record) { described_class.create! }

    it "creates a version, regardless" do
      expect { record.object_diff_trail.touch_with_version }.to change {
        ObjectDiffTrail::Version.count
      }.by(+1)
    end

    it "increments the `:updated_at` timestamp" do
      before = record.updated_at
      # Travel 1 second because MySQL lacks sub-second resolution
      Timecop.travel(1) do
        record.object_diff_trail.touch_with_version
      end
      expect(record.updated_at).to be > before
    end
  end
end
