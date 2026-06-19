const fs = require('fs');
const path = require('path');

const API_URL = process.env.OTIOSE_API_URL || 'http://127.0.0.1:3000/api/public/hallucinations';

async function sync() {
  console.log(`Initiating OTIOSE Execution Ledger Sync from ${API_URL}...`);
  
  const recordsDir = path.join(__dirname, '../records');
  if (!fs.existsSync(recordsDir)) {
    fs.mkdirSync(recordsDir, { recursive: true });
  }

  try {
    const res = await fetch(API_URL);
    if (!res.ok) {
      throw new Error(`API returned ${res.status} ${res.statusText}`);
    }

    const { records } = await res.json();

    if (!records || records.length === 0) {
      console.log('No records returned from the API.');
      return;
    }

    for (const record of records) {
      console.log(`\\nProcessing Record: ${record.slug} (${record.title})`);
      
      const targetDir = path.join(recordsDir, record.slug);
      if (!fs.existsSync(targetDir)) {
        fs.mkdirSync(targetDir, { recursive: true });
      }

      if (record.translations) {
        for (const lang of Object.keys(record.translations)) {
          const transData = record.translations[lang];
          let content = transData.content || '';
          
          if (transData.mastermind_answer && transData.mastermind_answer.trim() !== '') {
            content += '\\n\\n---\\n\\n**[MASTERMIND LOG]**\\n\\n' + transData.mastermind_answer.trim();
          }

          const filePath = path.join(targetDir, `${lang}.md`);
          fs.writeFileSync(filePath, content, 'utf8');
        }
        console.log(`  -> Successfully mirrored ${Object.keys(record.translations).length} languages for '${record.slug}'.`);
      } else {
        console.log(`  -> No translations found for '${record.slug}'.`);
      }
    }
    
    console.log('\\nSync complete.');
  } catch (error) {
    console.error('Sync failed:', error.message);
  }
}

sync();
