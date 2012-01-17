describe :mutex_synchronize, :shared => true do
  it "wraps the lock/unlock pair in an ensure" do
    m1 = Mutex.new
    m2 = Mutex.new
    m2.lock

    th = Thread.new do
      lambda do
        m1.synchronize do
          m2.lock
          raise Exception
        end
      end.should raise_error(Exception)
    end

    Thread.pass while th.status and th.status != "sleep"

    m1.locked?.should be_true
    m2.unlock
    th.join
    m1.locked?.should be_false
  end
end
