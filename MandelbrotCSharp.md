
```
		private void Form1_Load(object sender, EventArgs e)
		{
			DrawM();
		}

		private void Form1_Resize(object sender, EventArgs e)
		{
			DrawM();
		}

		private void DrawM()
		{
			Bitmap b = new Bitmap(this.Width, this.Height);

			for (int i = 0; i < b.Width; i++)
				for (int j = 0; j < b.Height; j++)
				{
					double CIm = (j - this.Height / 2) / 210.0;
					double CRe = (i - this.Width / 2) / 210.0;

					double ZRe = 0, ZIm = 0;
					int loop = 0;
					while (loop < 25 && Math.Sqrt(ZRe * ZRe + ZIm * ZIm) < 5)
					{
						double ZReNew = (ZRe * ZRe - ZIm * ZIm) + CRe;
						ZIm = 2 * ZRe * ZIm + CIm;
						ZRe = ZReNew;
						loop++;
					}
					int R = (loop * 13) % 256;
					int G = (loop * 117) % 256;
					int B = (loop * 679) % 256;
					if (loop == 25)
					{
						R = G = B = 0;
					}

					b.SetPixel(i, j, Color.FromArgb(255, R, G, B));
				}

			this.BackgroundImage = b;
		}

```