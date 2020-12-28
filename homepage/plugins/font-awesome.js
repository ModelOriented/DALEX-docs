import Vue from 'vue'
import { library } from '@fortawesome/fontawesome-svg-core'
import { faBookOpen, faAngleRight, faAngleLeft, faPlay } from '@fortawesome/free-solid-svg-icons'
import { faNewspaper } from '@fortawesome/free-regular-svg-icons'
import { faRProject, faPython } from '@fortawesome/free-brands-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

library.add(faNewspaper)
library.add(faBookOpen, faAngleLeft, faAngleRight, faPlay)
library.add(faRProject, faPython)
Vue.component('font-awesome-icon', FontAwesomeIcon)
