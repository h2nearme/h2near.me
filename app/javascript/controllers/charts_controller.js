import Rails from "@rails/ujs";
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "container", "display", "sum" ]

  connect() {
    function formatTime(secs) {
      const hours = Math.floor(secs / (60 * 60));
     
      const divisor_for_minutes = secs % (60 * 60);
      const minutes = Math.floor(divisor_for_minutes / 60);
   
      const divisor_for_seconds = divisor_for_minutes % 60;
      const seconds = Math.ceil(divisor_for_seconds);
      return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    }

    Object.assign(this, this.containerTarget.dataset)
    this.durationOptions = {
      library: {
        borderRadius: 4,
        scales: {
            y: {
                ticks: {
                    callback: function(label, index, labels) {
                      return formatTime(label);
                    }
                }
            },
            x: {
              ticks: {
                  callback: function(label, index) {
                    if (this.getLabelForValue(label).includes('Week')) {
                      return this.getLabelForValue(label).substr(0, 7)
                    } else {
                      return this.getLabelForValue(label);
                    }
                  }
              }
          }
        },
        plugins: {
          tooltip: {
              callbacks: {
                  label: function(context) {
                    return formatTime(context.raw);
                  },
                  title: function(context) {
                    if (context[0].label.includes('Week')) {
                      return context[0].label.substr(0, 7)
                    } else {
                      return context[0].label;
                    }
                  }
              }
          }
        }
      }
    }
    const minMax = this.chartId.includes('mood') ? {min: 0, max: 5} : {}
    this.quantityOptions = {
      library: {
        borderRadius: 4,
        scales: {
              x: {
                ticks: {
                    callback: function(label, index) {
                      if (this.getLabelForValue(label).includes('Week')) {
                        return this.getLabelForValue(label).substr(0, 7)
                      } else {
                        return this.getLabelForValue(label);
                      }
                    }
                }
            },
            y: {
              display: false,
              ...minMax
            }
        },
        plugins: {
          tooltip: {
              callbacks: {
                  label: function(context) {
                    return context.raw;
                  },
                  title: function(context) {
                    if (context[0].label.includes('Week')) {
                      return context[0].label.substr(0, 7)
                    } else {
                      return context[0].label;
                    }
                  }
              }
          }
        }
      }
    }
    const setChartOptions = () => {
      const chart = Chartkick.charts[this.chartId]
      if (!chart) return;
      if (this.type === 'duration') {
        const options = {...this.durationOptions, ...chart.getOptions()}
        chart.setOptions(options)
      } else if (this.type == 'quantity') {
        const options = {...this.quantityOptions, ...chart.getOptions()}
        chart.setOptions(options)
      }
      this.displaySum(Chartkick.charts[this.chartId].data)
    }
    window.addEventListener('chartkick:load', setChartOptions);
    document.addEventListener('turbo:load', setChartOptions);
  }

  reload() {
    Object.assign(this, this.containerTarget.dataset)
    this.changeTimePeriod(this.date)
  }

  previous() {
    const timeSkip = this.formatTimeSkip('back')
    const newDate = this.formatNextDate(timeSkip)
    this.changeTimePeriod(newDate)
  }

  next() {
    const timeSkip = this.formatTimeSkip('forward')
    const newDate = this.formatNextDate(timeSkip)
    this.changeTimePeriod(newDate)
  }

  formatTimeSkip(direction) {
    if(this.variant === 'week') {
      return (direction === 'forward' ? 7 : -7)
    } else if (this.variant === 'month') {
      const numberOfDaysInCurrentMonth = new Date(new Date(this.date.replace(/-/g, "/")).getFullYear(), new Date(this.date.replace(/-/g, "/")).getMonth() + 1, 0).getDate();
      if (direction === 'forward') {
        return (numberOfDaysInCurrentMonth - new Date(this.date.replace(/-/g, "/")).getDate()) + 1
      } else {
        return (numberOfDaysInCurrentMonth + 1) * -1
      }
    } else if (this.variant === 'year') {
      return (direction === 'forward' ? 365 : -365)
    }
  }

  changeTimePeriod(newDate) {
    this.loadDates(newDate)
    this.date = newDate
    this.displayTarget.innerHTML = this.generateDisplayDate()
  }

  formatNextDate(multiplier) {
    const date = new Date(this.date.replace(/-/g, "/"));
    date.setDate(date.getDate() + multiplier);
    let month = date.getMonth() + 1
    if (month < 10) {
      month = `0${month}`
    }
    return `${date.getFullYear()}-${month}-${date.getDate()}`
  }

  generateDisplayDate() {
    if (this.variant === 'week') {
      return this.displayDateWeek()
    } else if (this.variant === 'month') {
      const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
      return `${months[new Date(this.date.replace(/-/g, "/")).getMonth()]} ${new Date(this.date.replace(/-/g, "/")).getFullYear()}`
    } else if (this.variant === 'year') {
      return new Date(this.date.replace(/-/g, "/")).getFullYear()
    }
  }

  displayDateWeek() {
    const parsedDate = new Date(this.date.replace(/-/g, "/"))
    const from = this.fancyFormatDate(parsedDate)
    parsedDate.setDate(parsedDate.getDate() + 6)
    // USE 6 HERE BECAUSE LAST DISPLAY DATE IS 6 DAYS AFTER THE FIRST
    const to = this.fancyFormatDate(parsedDate)
    return `${from} until ${to}`
  }

  fancyFormatDate(date) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    return `${months[date.getMonth()]} ${date.getDate()} - ${date.getFullYear()}`
  }

  loadDates(dateMarker) {
    Rails.ajax({
      type: "GET",
      url: `${this.containerTarget.dataset.url}/?marker_date=${dateMarker}`,
      dataType: "json",
      success: (data) => {
        this.setupSuccess(data)
      },
      error: (data) => {
        this.setupError();
      }
    });
  }

  updateOptions(chart) {
    const currentOptions = chart.getOptions()
    delete currentOptions.library
    if(this.type === 'duration') {
      return {...currentOptions, ...this.durationOptions}
    } else if(this.type === 'quantity') {
      return {...currentOptions, ...this.quantityOptions}
    }
  }

  displaySum(data) {
    if(this.total === 'true') {
      const sum = data.reduce((sum, item) => sum + item[1], 0)
      this.sumTarget.innerHTML = `${this.variant.charAt(0).toUpperCase() + this.variant.slice(1)} total: ${sum > 0 ? (Math.round(sum * 100) / 100) : 0} ${this.unit}`
    }
  }

  setupSuccess(data) {
    this.element.removeAttribute('data-balloon-visible')
    this.element.removeAttribute('data-balloon-pos')
    const chart = Chartkick.charts[this.chartId]
    let options = this.updateOptions(chart)
    this.displaySum(data)
    chart.updateData(data, options)
  }

  setupError() {
    this.element.setAttribute('aria-label', "Error loading content")
    this.element.setAttribute('data-balloon-visible', true)
    this.element.setAttribute('data-balloon-pos', 'up')
  }
}


