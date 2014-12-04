{
  :en => {
    :'i18n' => {
      :plural => {
        :rule => lambda { |n| n == 1 ? :one : :other }
      }
    }
  },
  :ru => {
    :'i18n' => {
      :inflections => {
        :gender => {
           f: :female,
           m: :male,
           n: :neuter,
           female: :f,
           male: :m,
           neuter: :n,
           man: :male,
           woman: :female,
           default:  :n
        }
      }
    }
  }
}