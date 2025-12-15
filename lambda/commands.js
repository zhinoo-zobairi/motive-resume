const HEADERS = {
  'Content-Type': 'application/json',
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'OPTIONS,POST',
  'Access-Control-Allow-Headers': 'Content-Type'
};

exports.handler = async (event) => {
  if (event?.requestContext?.http?.method === 'OPTIONS') {
    return { statusCode: 204, headers: HEADERS, body: '' };
  }

  let body = {};
  try {
    body = event?.body
      ? (typeof event.body === 'string' ? JSON.parse(event.body) : event.body)
      : {};
  } catch {
    return {
      statusCode: 400,
      headers: HEADERS,
      body: JSON.stringify({ type: 'error', message: 'Invalid request body' })
    };
  }

  const command = (body.command || '').trim().toLowerCase();

  if (!command) {
    return {
      statusCode: 400,
      headers: HEADERS,
      body: JSON.stringify({ type: 'error', message: 'No command provided' })
    };
  }

  const text = (message) => ({
    type: 'text',
    body: message
  });

  const redirect = (url) => ({
    type: 'redirect',
    url
  });

  const responses = {
    help: {
    type: 'text',
    body: [
      'Type a command to explore:',
      '',
      'Core',
      '  whoami        – context and background',
      '  shadow        – what I want to learn during shadowing and why',
      '  thinking      – how I approach problems',
      '  work          – systems and projects I’ve worked on',
      '  stack         – tools I’ve used',
      '  growth        – what I’m optimizing for next',
      '  principles    – how I work with others',
      '',
      'Links',
      '  github        – open GitHub profile',
      '  linkedin      – open LinkedIn profile',
      '',
      'Utility',
      '  clear         – clear the screen',
      '  exit          – end the session'
    ].join('\n')
  },
    whoami: {
  type: 'text',
  body: [
    'user: zhinoo',
    'status: transitioning from working student to full-time engineer',
    'focus: backend systems'
  ].join('\n')
},
  shadow: {
  type: 'text',
  body: [
    'Shadowing request: 4 to 8 weeks',
    '',
    'What I want to learn:',
    '- How your team designs and operates backend systems in production',
    '- How you approach correctness, security, and long-term architecture decisions',
    '- How ownership looks in your environment (on-call signals, incidents, tradeoffs)',
    '',
    'Growth area (where I want to level up):',
    '- Production-grade backend depth: design tradeoffs, reliability patterns, and security-first thinking',
    '',
    'Intent:',
    'Shadowing is my bridge into the team. The objective is a full-time backend position once my student role ends.'
  ].join('\n')
},
  thinking: {
  type: 'text',
  body: [
    'I approach new problems with an open and curious mindset.',
    '',
    'I’m comfortable being trained, adjusting my understanding, and refining how I think.',
    '',
    'To me, most things are figureoutable with the right mental model and enough iteration.',
    'That belief keeps me calm under ambiguity and persistent under pressure.',
    '',
    'I’m resourceful in how I reason things through, and I keep asking “why”',
    'until I can explain the idea back to myself clearly and without gaps.'
  ].join('\n')
},
    work: {
  type: 'text',
  body: [
    'Recently, I’ve been working on:',
      '- Wiring APIs and integration flows',
      '- Working with cloud infrastructure',
      '- Building small AI agents end to end to understand how the pieces fit together',
  ].join('\n')
},
  stack: {
  type: 'text',
  body: [
    'Backend & APIs',
    '- Node.js',
    '- Python',
    '',
    'Cloud & Infrastructure',
    '- AWS',
    '',
    'Dev & Tooling',
    '- Git & GitHub',
    '- GitHub Actions (basic CI/CD)'
  ].join('\n')
},
  growth: {
  type: 'text',
  body: [
    'I’m intentionally not optimizing for comfort.',
      '',
      'I’m looking for a team where I can:',
      '- Learn from experienced engineers and architects',
      '- Grow into complex systems and gradually take on more ownership',
      '',
      'I’m especially interested in backend-heavy environments, including systems where',
      'machine learning components are part of a larger architecture.'

  ].join('\n')
},
   principles: {
  type: 'text',
  body: [
    'My internal KPI is clarity.',
    '',
    'Friction is a signal, not a blocker:',
    '- When something feels hard, I don’t interpret that as incompetence',
    '- I treat it as a signal that my mental model is incomplete',
    '- So I slow down, zoom in, and break down the problem until it makes sense',
    '',
    'Documentation is leverage for me:',
    '- I write things down to externalize memory, compress future thinking,',
    '  and make knowledge transferable to teammates and future-me',
    '- GitHub issues, Markdown notes, structured breakdowns: this is how I scale myself',
    '',
    'Truth over comfort:',
    '- I explicitly push back on vague or hand-wavy explanations',
    '- Clear language matters because vague wording hides vague thinking',
    '',
    'I’m deliberate about ROI:',
    '- I don’t chase hype blindly. I weigh value',
    '',
    'Discipline over motivation:',
    '- I trained myself to rely on discipline instead of motivation',
    '- That’s where my confidence comes from'
  ].join('\n')
},

    github: redirect('https://github.com/zhinoo-zobairi'),
    linkedin: redirect('https://www.linkedin.com/in/zhinoo-zobairi'),

    clear: { type: 'clear' },
    exit: text('Session terminated.')
  };

  const response = responses[command];

  if (!response) {
    return {
      statusCode: 200,
      headers: HEADERS,
      body: JSON.stringify({
        type: 'error',
        message: `Command not found: ${command}`
      })
    };
  }

  return {
    statusCode: 200,
    headers: HEADERS,
    body: JSON.stringify(response)
  };
};
