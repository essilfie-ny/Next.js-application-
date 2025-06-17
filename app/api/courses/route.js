import pool from '@/lib/db';

export async function GET() {
  try {
    const result = await pool.query('SELECT * FROM courses');
    return Response.json(result.rows);
  } catch (err) {
    console.error('Error fetching courses:', err);
    return new Response(JSON.stringify({ error: 'Failed to fetch courses' }), {
      status: 500,
    });
  }
}
