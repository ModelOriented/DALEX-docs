(window.webpackJsonp=window.webpackJsonp||[]).push([[6],{233:function(t,e,n){t.exports=n.p+"img/dalex.856bddb.svg"},247:function(t,e,n){var content=n(252);"string"==typeof content&&(content=[[t.i,content,""]]),content.locals&&(t.exports=content.locals);(0,n(32).default)("1b7833da",content,!0,{sourceMap:!1})},251:function(t,e,n){"use strict";n(247)},252:function(t,e,n){(e=n(31)(!1)).push([t.i,".main-page{width:100%;min-height:100vh;background:#fff;position:relative}.main-page>.logo-container{position:relative;min-height:50vh;overflow:hidden}.main-page>.logo-container>.logo{position:absolute;left:-10%;transform:scaleX(-1);top:20px;height:120%;-webkit-animation:appear 2s;animation:appear 2s}.main-page>.hub{overflow-x:hidden}.main-page>.hub>a{border-color:#371ea3;color:#371ea3;-webkit-animation:appear 2s;animation:appear 2s}.main-page>.hub>a>.icon{font-size:10rem}.main-page>.hub>a:hover{background:#371ea3;color:#fff}.main-page>.quote{color:#371ea3}@-webkit-keyframes appear{0%{opacity:0}}@keyframes appear{0%{opacity:0}}.object-cover{-o-object-fit:contain!important;object-fit:contain!important}",""]),t.exports=e},274:function(t,e,n){"use strict";n.r(e);var o=[function(){var t=this.$createElement,e=this._self._c||t;return e("div",{staticClass:"logo-container hidden md:block"},[e("img",{staticClass:"logo",attrs:{src:n(233)}})])},function(){var t=this.$createElement,e=this._self._c||t;return e("div",{staticClass:"logo-container md:hidden"},[e("img",{staticClass:"logo",attrs:{src:n(233)}})])}],r=(n(60),{data:function(){return{links:[{label:"Dalex for Python",icon:["fab","python"],to:"/python"},{label:"Dalex for R",icon:["fab","r-project"],href:"https://modeloriented.github.io/DALEX/index.html"},{label:"Responsible ML blog",icon:["far","newspaper"],href:"https://medium.com/responsibleml"}]}},computed:{nuxtLinks:function(){return this.links.filter((function(t){return t.to}))},extLinks:function(){return this.links.filter((function(t){return t.href}))}}}),l=(n(251),n(34)),component=Object(l.a)(r,(function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"main-page grid gap-4 md:grid-cols-3"},[n("div",{staticClass:"quote md:col-span-3 text-4xl font-medium text-center italic p-10 md:absolute w-screen"},[t._v("\n    On a mission to responsibly build machine learning predictive models\n  ")]),t._v(" "),t._m(0),t._v(" "),n("div",{staticClass:"hub flex flex-wrap p-8 xl:p-32 md:col-span-2 content-around justify-center ml:justify-end"},[t._l(t.nuxtLinks,(function(e){return n("NuxtLink",{key:e.label,staticClass:"block rounded-2xl border-2 w-64 h-64 text-center p-4 space-y-2 cursor-pointer duration-300 easy-in m-8",attrs:{to:e.to}},[n("font-awesome-icon",{staticClass:"icon block",attrs:{icon:e.icon}}),t._v(" "),n("span",{staticClass:"block text-2xl font-bold"},[t._v(t._s(e.label))])],1)})),t._v(" "),t._l(t.extLinks,(function(e){return n("a",{key:e.label,staticClass:"block rounded-2xl border-2 w-64 h-64 text-center p-4 space-y-2 cursor-pointer duration-300 easy-in m-8",attrs:{href:e.href}},[n("font-awesome-icon",{staticClass:"icon block",attrs:{icon:e.icon}}),t._v(" "),n("span",{staticClass:"block text-2xl font-bold"},[t._v(t._s(e.label))])],1)}))],2),t._v(" "),t._m(1)])}),o,!1,null,null,null);e.default=component.exports}}]);