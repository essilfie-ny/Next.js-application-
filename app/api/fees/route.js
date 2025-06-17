import pool from '@/lib/db';

export async function GET() {
  try {
    const result = await pool.query('SELECT * FROM fees');
    return Response.json(result.rows);
  } catch (err) {
    console.error('Error fetching fees:', err);
    return new Response(JSON.stringify({ error: 'Failed to fetch fees' }), {
      status: 500,
    });
  }
}
