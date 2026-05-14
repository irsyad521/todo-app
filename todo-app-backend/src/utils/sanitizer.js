import xss from 'xss';

const filter = new xss.FilterXSS({
  whiteList: {},
  stripIgnoreTag: true,
  stripIgnoreTagBody: ['script']
});

export const sanitize = (val) => {
  if (typeof val !== 'string') return val;
  return filter.process(val);
};

export const hasXSS = (val) => {
  if (typeof val !== 'string') return false;
  return /<[^>]*>|javascript:|onerror=|onload=/i.test(val);
};