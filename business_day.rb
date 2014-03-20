class Date
  def self.next_business_day
    date = Date.today
    date.business_day? ? date : date.next_business_day
  end

  def business_day?
    wday != 6 && wday != 0
  end

  def next_business_day
    date = self + 1
    date += 1 until date.business_day?
    date
  end

  def previous_business_day
    date = self - 1
    date -= 1 until date.business_day?
    date
  end
end

require "date"
Date.new(2013, 05, 17).business_day? or raise "Fail"
Date.new(2013, 05, 18).business_day? and raise "Fail"
Date.new(2013, 05, 19).business_day? and raise "Fail"
Date.new(2013, 05, 20).business_day? or raise "Fail"
