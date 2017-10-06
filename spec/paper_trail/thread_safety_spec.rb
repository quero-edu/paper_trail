require "spec_helper"

RSpec.describe ObjectDiffTrail do
  describe "#set_object_diff_trail_whodunnit" do
    it "is thread-safe" do
      blocked = true
      slow_thread = Thread.new do
        controller = TestController.new
        controller.send(:set_object_diff_trail_whodunnit)
        sleep(0.001) while blocked
        described_class.whodunnit
      end
      fast_thread = Thread.new do
        controller = TestController.new
        controller.send(:set_object_diff_trail_whodunnit)
        who = described_class.whodunnit
        blocked = false
        who
      end
      expect(fast_thread.value).not_to(eq(slow_thread.value))
    end
  end

  describe "#without_versioning" do
    it "is thread-safe" do
      enabled = nil
      slow_thread = Thread.new do
        Widget.new.object_diff_trail.without_versioning do
          sleep(0.01)
          enabled = Widget.object_diff_trail.enabled?
          sleep(0.01)
        end
        enabled
      end
      fast_thread = Thread.new do
        sleep(0.005)
        Widget.object_diff_trail.enabled?
      end
      expect(fast_thread.value).not_to(eq(slow_thread.value))
      expect(Widget.object_diff_trail.enabled?).to(eq(true))
      expect(described_class.enabled_for_model?(Widget)).to(eq(true))
    end
  end
end
